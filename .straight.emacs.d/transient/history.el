((magit-am
  ("--3way"))
 (magit-branch nil)
 (magit-cherry-pick
  ("--ff"))
 (magit-commit nil)
 (magit-diff
  ("--no-ext-diff" "--stat"))
 (magit-dispatch nil)
 (magit-fetch nil)
 (magit-gitignore nil)
 (magit-log
  ("-n256" "--graph" "--decorate")
  ("-n256" "--grep=gillespie" "--graph" "--decorate")
  ("-n256" "--grep=remove" "--graph" "--decorate")
  ("-n256" "--grep=Gillespie.jl" "--graph" "--decorate"))
 (magit-log:--grep "gillespie" "remove" "Gillespie.jl")
 (magit-merge nil)
 (magit-merge:--strategy "ours")
 (magit-pull nil)
 (magit-push nil)
 (magit-rebase nil)
 (magit-remote
  ("-f"))
 (magit-reset nil)
 (magit-run nil)
 (magit-stash nil
              ("--include-untracked"))
 (magit-submodule nil))
