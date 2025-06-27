class AbyssExplorer < Formula
  # cite Nielsen_2009: "https://doi.org/10.1109/TVCG.2009.116"
  desc "Visualize genome sequence assemblies"
  homepage "https://github.com/bcgsc/ABySS-explorer"
  url "https://github.com/bcgsc/ABySS-explorer/releases/download/v2.1.0/ABySS-explorer-2.1.0.tar.gz"
  sha256 "3f22d6d2a0bc5127453d6c9b7b6ddb609d602a3495384f73e603fe6b2967b3a7"
  license "GPL-3.0"
  head "https://github.com/bcgsc/ABySS-explorer.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "44e6a1c361f36b0a7316b4bfa45371f571743fb7ad19df0dc76bddd1dcd22d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e1f8ad29d192da909ac2ec6ea32eb7644e2dd9107e166c29aeef5a7d7f0fcdd"
  end

  depends_on "openjdk"

  def install
    libexec.install "ABySS-explorer.jar", "lib"
    (bin / "abyss-explorer").write <<~EOS
      #!/bin/sh
      set -eu
      exec #{Formula["openjdk"]/bin}/java -jar #{libexec}/ABySS-explorer.jar "$@"
    EOS
  end

  test do
    assert_predicate bin/"abyss-explorer", :executable?
    assert_predicate libexec/"ABySS-explorer.jar", :exist?
    # This test fails on CI, though it succeeds locally.
    assert_match "Build", shell_output("#{bin}/abyss-explorer --version") unless ENV["HOMEBREW_GITHUB_ACTIONS"]
  end
end
