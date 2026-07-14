class Gepard < Formula
  # cite Krumsiek_2007: "https://doi.org/10.1093/bioinformatics/btm039"
  desc "Genome Pair Rapid Dotter"
  homepage "https://cube.univie.ac.at/gepard"
  url "https://github.com/univieCUBE/gepard/blob/master/dist/Gepard-2.1.jar?raw=true"
  sha256 "5685d6b189e3951ef5153a9d6c6236fa5433465c533f6c47bf17e1a14bb97ac5"
  license "MIT"

  # Distributed as a raw-blob jar (Gepard-1.40.jar) whose filename version
  # cannot be derived from the vX.Y.Z release tags.
  livecheck do
    skip "distributed as a raw-blob jar with no matching release tag"
  end

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
