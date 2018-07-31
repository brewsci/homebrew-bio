class Cytoscape < Formula
  # cite Saito_2012 "https://doi.org/10.1038/nmeth.2212"
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"
  url "https://github.com/cytoscape/cytoscape/archive/3.6.1.tar.gz"
  sha256 "f172c9e459293661a83d2618da511901410336b76b0c1716697e60f821c2f150"

  depends_on :java => "1.8"

  def install
    ENV["JAVA_HOME"] = Formula["jdk@8"].prefix if ENV["CIRCLECI"]
    inreplace "cy.sh", "/home/linuxbrew/.linuxbrew/Cellar/cytoscape/3.6.1", prefix
    prefix.install %w[cy.sh apps gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cy.sh" => "cytoscape"
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
