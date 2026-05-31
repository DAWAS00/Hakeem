# Hakeem Project Rules & Workflows

This document outlines the mandatory rules and architectural standards for the Hakeem project. These rules must be followed in every session.

## 1. The "Think-Before-Act" Protocol
- **No Direct Implementation:** Never make code changes immediately upon receiving an idea or request.
- **Roadmap & Implementation Plan:** For every task, first research and then create a comprehensive roadmap and implementation plan.
- **Approval Flow:** Present the implementation plan to the user. Wait for explicit authorization before executing.
- **Post-Implementation:** Update the implementation plan file upon completion to reflect the final state and any deviations.

## 2. Architectural & Coding Standards
- **Clean Architecture:** Strictly adhere to Clean Architecture principles (Layers: Data, Domain, Presentation).
- **OOP Principles:** Follow SOLID principles and utilize design patterns where appropriate.
- **Code Optimization:** Continuously look for opportunities to optimize performance and readability.
- **Organization:** 
    - Create a separate file for every significant function, widget, or class to maintain maximum organization and testability.
    - Use highly descriptive and clear naming conventions.
    - If a function is deemed unnecessary for its current scope, move it to a designated `utils` or `deprecated` folder rather than deleting it if it holds potential future value.

## 3. Documentation & Clarity
- **The "Why" and "What":** Add meaningful comments to functions and complex logic. Focus on explaining *why* a certain approach was taken, not just *what* the code does.
- **Continuous Updates:** This `GEMINI.md` file is a living document. Update it as new rules or conventions emerge.

## 4. Skills & Expertise
- **Flutter Expert:** Always activate and utilize specialized Flutter skills (`flutter`, `flutter-architecting-apps`, `flutter-riverpod-expert`, etc.).
- **Strategic Implementation:** Consider the specific reasons for every feature (layout vs. architecture) and detail the implementation phases.

## 5. Version Control (Git/GitHub)
- **Commit Excellence:** Utilize specialized `git-commit` skills to ensure high-quality, conventional commit messages.
- **No Unbalanced Pushes:** Never push code to a remote repository without explicit user authorization.
## 6. Package Research & Optimization
- **Proactive Investigation:** Before implementing any new feature or logic, search for and evaluate third-party packages that could provide a more efficient, optimized, or standardized solution than a custom implementation.
- **Optimization Focus:** Prioritize packages that improve app performance, reduce boilerplate code, or enhance the user experience (e.g., specialized UI components, data processing libraries).
- **Plan Integration:** Include the package research and selection process in the initial implementation plan for every feature.
