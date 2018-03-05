# Feature tests

Each feature test smoke-tests one broad feature or area of the application. They can be written for TDD but their core purpose is catching regressions.

Rules:

- Write each integration test like it's a one-minute demo to Elon Musk. You're demonstrating the most important features of this interface, and nothing more. Only the most important behavior should be exercised, and only the most important assertions should be made.
- Each feature test has its own file. Generally, one (often multiple-paragraph) feature test per CRUD interface / "major" controller.
- Always start from the homepage. Avoid `visit` calls to other pages.
