-- ============================================================
-- 아카데미 사이트: 공지사항 + 교육일정 테이블 (M4)
-- Supabase 대시보드 → SQL Editor 에 붙여넣고 "Run" 실행
-- ============================================================

-- 1) 공지사항 테이블
create table if not exists public.notices (
  id          bigint primary key,
  title       text not null,
  content     text not null,
  date        text not null,
  created_at  timestamptz default now()
);

-- 2) 교육 일정 테이블
create table if not exists public.schedule (
  id          bigint primary key,
  date        text not null,   -- YYYY-MM-DD
  title       text not null,
  created_at  timestamptz default now()
);

-- ============================================================
-- RLS(행 수준 보안) 정책
-- 사이트는 publishable(anon) 키로 접속하므로 anon 읽기/쓰기를 허용합니다.
-- (기존 feedback 테이블과 동일한 개방 정책)
-- ============================================================

alter table public.notices  enable row level security;
alter table public.schedule enable row level security;

-- 공지사항: 누구나 읽기
create policy "notices_select" on public.notices
  for select using (true);
-- 공지사항: 누구나 쓰기/수정/삭제 (관리자 UI에서만 노출됨)
create policy "notices_insert" on public.notices
  for insert with check (true);
create policy "notices_update" on public.notices
  for update using (true);
create policy "notices_delete" on public.notices
  for delete using (true);

-- 교육 일정: 누구나 읽기
create policy "schedule_select" on public.schedule
  for select using (true);
-- 교육 일정: 누구나 쓰기/수정/삭제
create policy "schedule_insert" on public.schedule
  for insert with check (true);
create policy "schedule_update" on public.schedule
  for update using (true);
create policy "schedule_delete" on public.schedule
  for delete using (true);
