class Gepard < Formula
  desc "Genome Pair Rapid Dotter"
  homepage "http://cube.univie.ac.at/gepard"
  url "https://github.com/univieCUBE/gepard/blob/master/dist/Gepard-1.40.jar?raw=true"
  sha256 "9f35adefbc4843eb87e545bb54a47ef007ea02d145f2c13df86756e63bef8418"
  # cite Krumsiek_2007: "https://doi.org/10.1093/bioinformatics/btm039"

  depends_on :java

  def install
    jar = "Gepard-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "gepard"
  end

  test do
    # No test because this is a GUI
  end
end
