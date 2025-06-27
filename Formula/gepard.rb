class Gepard < Formula
  # cite Krumsiek_2007: "https://doi.org/10.1093/bioinformatics/btm039"
  desc "Genome Pair Rapid Dotter"
  homepage "http://cube.univie.ac.at/gepard"
  url "https://github.com/univieCUBE/gepard/blob/master/dist/Gepard-1.40.jar?raw=true"
  sha256 "9f35adefbc4843eb87e545bb54a47ef007ea02d145f2c13df86756e63bef8418"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra: "c8e3c9921c645c8c1656980a39168078a369dfbe7b56cc77f74fdd3741eca7d4"
  end

  depends_on "openjdk"

  def install
    jar = "Gepard-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "gepard"
  end

  test do
    # No test because this is a GUI
    nil
  end
end
