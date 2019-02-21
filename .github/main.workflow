workflow "Push" {
  on = "push"
  resolves = ["Deploy formula.json"]
}

action "Make formula.json" {
  uses = "docker://linuxbrew/brew"
  runs = "make"
  args = ["setup", "all"]
}

action "Deploy formula.json" {
  needs = "Make formula.json"
  uses = "docker://linuxbrew/brew"
  runs = "make"
  args = "deploy"
  secrets = ["HOMEBREW_GITHUB_API_TOKEN"]
}
