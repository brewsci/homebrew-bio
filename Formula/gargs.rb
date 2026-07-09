class Gargs < Formula
  desc "Better(?) xargs in Go: run commands in parallel with templating"
  homepage "https://github.com/brentp/gargs"
  url "https://github.com/brentp/gargs/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "635dbaa6def7438240032a6ea70ae0f2249868d50df17e16bfd564591e30692c"
  license "Apache-2.0"
  head "https://github.com/brentp/gargs.git", branch: "master"

  depends_on "go" => :build

  def install
    # Upstream predates Go modules; initialise one so the build resolves deps.
    system "go", "mod", "init", "github.com/brentp/gargs"
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(output: bin/"gargs"), "."
  end

  test do
    output = pipe_output("#{bin}/gargs -p 2 'echo hello {}'", "world\n")
    assert_match "hello world", output
  end
end
