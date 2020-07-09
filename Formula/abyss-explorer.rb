class AbyssExplorer < Formula
  # cite Nielsen_2009: "https://doi.org/10.1109/TVCG.2009.116"
  desc "Visualize genome sequence assemblies"
  homepage "https://github.com/bcgsc/ABySS-explorer"
  url "https://github.com/bcgsc/ABySS-explorer/releases/download/v2.1.0/ABySS-explorer-2.1.0.tar.gz"
  sha256 "3f22d6d2a0bc5127453d6c9b7b6ddb609d602a3495384f73e603fe6b2967b3a7"
  head "https://github.com/bcgsc/ABySS-explorer.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "31a7d44cd130d195138d2ac617f0f504c23e3f5acf11fa41622c38ba9c267a69" => :sierra
    sha256 "998383b13779fb6ccad8dec1a59fe19e1f8e1958c81f271a971bb6b3a0fdeaab" => :x86_64_linux
  end

  depends_on :java

  def install
    libexec.install "ABySS-explorer.jar", "lib"
    (bin / "abyss-explorer").write <<~EOS
      #!/bin/sh
      set -eu
      exec java -jar #{libexec}/ABySS-explorer.jar "$@"
    EOS
  end

  test do
    assert_predicate bin/"abyss-explorer", :executable?
    assert_predicate libexec/"ABySS-explorer.jar", :exist?
    # This test fails on CI, though it succeeds locally.
    assert_match "Build", shell_output("#{bin}/abyss-explorer --version") unless ENV["CI"]
  end
end
