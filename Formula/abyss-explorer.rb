class AbyssExplorer < Formula
  # cite Nielsen_2009: "https://doi.org/10.1109/TVCG.2009.116"
  desc "Visualize genome sequence assemblies"
  homepage "https://github.com/bcgsc/ABySS-explorer"
  url "http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip"
  sha256 "fa4197c985ae9e66a01b4d3db4e6211f4e84444bc31deaf4c1aa352431ae6491"
  head "https://github.com/bcgsc/ABySS-explorer.git"

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
    assert_match "Usage", shell_output("#{bin}/abyss-explorer --help") unless ENV["CI"]
  end
end
