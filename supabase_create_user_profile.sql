-- ============================================================
-- 교육 신청(자동 승인) 프로필 생성 RPC
-- Supabase 대시보드 → SQL Editor 에 붙여넣고 "Run"
--
-- 목적: 회원가입 시 profiles 테이블에 교육생 프로필을 생성.
--   RLS(행 수준 보안)에 막히지 않도록 SECURITY DEFINER 함수로 처리.
--   이메일 인증 여부와 무관하게(세션 없이도) anon 클라이언트가 호출 가능.
-- ============================================================

create or replace function public.create_user_profile(
  p_email text,
  p_name  text
) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (email, name, role)
  values (lower(p_email), p_name, 'user')
  on conflict (email) do update
    set name = excluded.name;
end;
$$;

-- 익명/인증 사용자 모두 호출 허용 (신청 폼은 로그인 전 상태)
grant execute on function public.create_user_profile(text, text) to anon, authenticated;

-- 참고: profiles 테이블에 email 유니크 제약이 없다면 아래를 먼저 실행하세요.
--   alter table public.profiles add constraint profiles_email_unique unique (email);
