class WebinCli < Formula
  desc "ENA Webin command-line submission tool"
  homepage "https://github.com/enasequence/webin-cli"
  url "https://github.com/enasequence/webin-cli/releases/download/v1.8.11/webin-cli-1.8.11.jar"
  sha256 "50862324dcc98aeef23f9789e6eac9eb37bd04378baaf2d17dfa97644c1a1e66"

  depends_on :java

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
