class WebinCli < Formula
  desc "ENA Webin command-line submission tool"
  homepage "https://github.com/enasequence/webin-cli"
  url "https://github.com/enasequence/webin-cli/releases/download/v1.8.11/webin-cli-1.8.11.jar"
  sha256 "50862324dcc98aeef23f9789e6eac9eb37bd04378baaf2d17dfa97644c1a1e66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "883d06b50dab13a9ca315938c88d552528ee51812db91e39c0cd078a256393af"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cfb18450e818a8b6b984c34fb11d5fa3ed4d55385ebe3a9a2d5ae82dfad9a89b"
  end

  depends_on "openjdk"

  def install
    exe = "webin-cli"
    jar = "#{exe}-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, exe
  end

  test do
    assert_match "Missing", shell_output("#{bin}/webin-cli 2>&1", 1)
  end
end
