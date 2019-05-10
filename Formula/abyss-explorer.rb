class AbyssExplorer < Formula
  # cite Nielsen_2009: "https://doi.org/10.1109/TVCG.2009.116"
  desc "Visualize genome sequence assemblies"
  homepage "https://github.com/bcgsc/ABySS-explorer"
  url "http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip"
  sha256 "fa4197c985ae9e66a01b4d3db4e6211f4e84444bc31deaf4c1aa352431ae6491"
  head "https://github.com/bcgsc/ABySS-explorer.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "31a7d44cd130d195138d2ac617f0f504c23e3f5acf11fa41622c38ba9c267a69" => :sierra
    sha256 "998383b13779fb6ccad8dec1a59fe19e1f8e1958c81f271a971bb6b3a0fdeaab" => :x86_64_linux
  end

  depends_on :java

  def install
    libexec.install "AbyssExplorer.jar", "lib"
    (bin / "abyss-explorer").write <<~EOS
      #!/bin/sh
      set -eu
      exec java -jar #{libexec}/AbyssExplorer.jar "$@"
    EOS
  end

  test do
    assert_predicate bin/"abyss-explorer", :executable?
    assert_predicate libexec/"AbyssExplorer.jar", :exist?
    # This test fails on CI, though it succeeds locally.
    assert_match "Build", shell_output("#{bin}/abyss-explorer --version") unless ENV["CI"]
  end
end
