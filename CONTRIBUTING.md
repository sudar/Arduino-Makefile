# Contributing To Arduino Makefile

Community made patches, localizations, bug reports, documentation and contributions are always welcome and are crucial to the success of this project.

When contributing please ensure you follow the guidelines below so that we can keep on top of things.

## Getting Started

Submit a ticket for your issue, assuming one does not already exist.

- Raise it on our [Issue Tracker](https://github.com/sudar/Arduino-Makefile/issues)
- Clearly describe the issue including steps to reproduce the bug.
- Make sure you fill in the earliest version that you know has the issue as well as the following
    - Your operating system (Mac, Linux/Unix, Windows)
    - Your Arduino IDE version
    - Snippet of your makefile

## Making Changes

- Fork the repository on GitHub
- Make the changes to your forked repository
- Update the [changelog file](HISTORY.md) and add a note about your change. If possible prefix it with either Fix, Tweak or New
- If you are adding or changing the behavior of any variable, then update the corresponding documentation in the [arduino-mk-vars.md](arduino-mk-vars.md) file as well
- When committing, reference your issue (if present) and include a note about the fix
    - If possible (and if makes sense) do atomic commits
    - Try to follow [this guideline](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) while choosing the git commit message
    - If it makes sense then add a unit test case for the changes that you are making
- Push the changes to your fork and submit a pull request to the 'master' branch of the this repository

At this point you're waiting on us to merge your pull request. We'll review all pull requests, and make suggestions and changes if necessary.

# Additional Resources

- [General GitHub Documentation](http://help.github.com/)
- [GitHub Pull Request documentation](http://help.github.com/send-pull-requests/)
- [Guide about contributing code in GitHub](http://sudarmuthu.com/blog/contributing-to-project-hosted-in-github)
