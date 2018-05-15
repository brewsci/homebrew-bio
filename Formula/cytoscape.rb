class Cytoscape < Formula
  # cite "https://doi.org/10.1038/nmeth.2212"
  desc "Network Data Integration, Analysis, and Visualization in a Box"
  homepage "http://www.cytoscape.org/"

  url "http://chianti.ucsd.edu/cytoscape-3.4.0/cytoscape-3.4.0.tar.gz"
  sha256 "e20a04b031818005090bd65b78bb08813b7a8e018c73496d41f2f00014d6ae18"

  depends_on :java => "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %w[cytoscape.sh apps gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
  end

  def caveats
    "Make sure you have Java 8 on this machine and set your JAVA_HOME to 8"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
