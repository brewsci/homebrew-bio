- [ ] Have you followed the [guidelines for contributing](https://github.com/brewsci/homebrew-bio/blob/master/CONTRIBUTING.md)?
- [ ] Have you checked that there aren't other open [pull requests](https://github.com/brewsci/homebrew-bio/pulls) for the same formula update/change?
- [ ] Have you built your formula locally with `HOMEBREW_DEVELOPER=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose --keep-tmp ./Formula/<FORMULA>.rb`, where `FORMULA` is the name of the formula you're submitting?
- [ ] Does your formula have no offenses with `brew style /path/to/formula.rb`?
- [ ] Does your formula pass `brew audit --formula brewsci/bio/<FORMULA> --online --git --skip-style`?
- [ ] Does your formula pass `brew linkage --cached --test --strict brewsci/bio/<FORMULA>` after manual installation?

-----
