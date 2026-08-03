alter table hanja.exam_rounds
  add column if not exists is_hidden boolean not null default false,
  add column if not exists hidden_at timestamptz;

create index if not exists exam_rounds_is_hidden_created_at_idx
  on hanja.exam_rounds (is_hidden, created_at desc);
