class Cytoscape < Formula
  # cite Saito_2012 "https://doi.org/10.1038/nmeth.2212"
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"

  url "https://github.com/cytoscape/cytoscape/archive/3.6.1.tar.gz"
  sha256 "e20a04b031818005090bd65b78bb08813b7a8e018c73496d41f2f00014d6ae18"

  depends_on :java => "1.8"

  def install
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %w[cytoscape.sh apps gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
    (bin/"cytoscape").write_env_script libexec/"cytoscape", Language::Java.java_home_env("1.8")
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
