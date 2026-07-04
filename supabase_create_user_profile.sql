-- ============================================================
-- 교육 신청(자동 승인) 프로필 생성 RPC (v2)
-- Supabase 대시보드 → SQL Editor 에 붙여넣고 "Run"
--
-- 목적: 회원가입 시 profiles 테이블에 교육생 프로필을 생성.
--   - RLS(행 수준 보안)에 막히지 않도록 SECURITY DEFINER 함수로 처리
--   - profiles.id (NOT NULL)에는 방금 가입한 auth 사용자의 id를 조회해 채움
--   - 세션 없이도(anon) 호출 가능
-- ============================================================

create or replace function public.create_user_profile(p_email text, p_name text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  -- 방금 가입한 auth 사용자의 id를 이메일로 조회
  select id into v_id from auth.users where email = lower(p_email) limit 1;

  insert into public.profiles (id, email, name, role)
  values (v_id, lower(p_email), p_name, 'user')
  on conflict (email) do update
    set name = excluded.name;
end;
$$;

grant execute on function public.create_user_profile(text, text) to anon, authenticated;

-- 참고: profiles 테이블에 email 유니크 제약이 없어 on conflict 오류가 나면 먼저 실행:
--   alter table public.profiles add constraint profiles_email_unique unique (email);
