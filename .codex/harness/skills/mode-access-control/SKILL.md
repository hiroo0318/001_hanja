---
name: mode-access-control
description: "Design and verify Mom/Yoonwoo learning-mode visibility and access control for this Hanja learning site. Trigger when planning or implementing profiles, permissions, RLS, or protected controls."
---

# Mode access control

1. Separate display rules from authorization rules before implementation.
2. Define what each mode can view, navigate, randomize, and change.
3. Treat a profile picker as a convenience UI, not security, unless an authentication mechanism protects the mom-only actions.
4. Enforce data-changing or protected operations with Supabase policies and server-side checks as appropriate.
5. Test both normal UI paths and direct requests to protected operations.
