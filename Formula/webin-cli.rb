class WebinCli < Formula
  desc "ENA Webin command-line submission tool"
  homepage "https://github.com/enasequence/webin-cli"
  url "https://github.com/enasequence/webin-cli/releases/download/v4.4.0/webin-cli-4.4.0.jar"
  sha256 "5db9c8ff5d8463c957596fccd3d0c6e41ba2a55723c4dd0dc94f107946fb7b70"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07b5fc808eb0bad124d82c3461b3e69388aff96bb2d5c30f5a88a91b15e6c378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07b5fc808eb0bad124d82c3461b3e69388aff96bb2d5c30f5a88a91b15e6c378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b5fc808eb0bad124d82c3461b3e69388aff96bb2d5c30f5a88a91b15e6c378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6044d1fb34889dc9c1f33ac445e35d42c9307b83ab1b371459ec7d15cc92fde6"
  end

  depends_on "openjdk"

  def install
    exe = "webin-cli"
    jar = "#{exe}-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, exe
  end

  test do
    assert_match "Missing", shell_output("#{bin}/webin-cli 2>&1", 2)
  end
end
