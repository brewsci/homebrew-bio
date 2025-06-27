class Artemis < Formula
  # cite Carver_2011: "https://doi.org/10.1093/bioinformatics/btr703"
  desc "Genome browser and annotation tool"
  homepage "https://www.sanger.ac.uk/science/tools/artemis"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v17/v17.0.1/artemis-v17.0.1.jar"
  sha256 "8703fd02df01084c8dcb06abf181b378cdf4dd9ba70d71fbd950c2056fefe932"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "afe9a473decfdaac3d4d4da8feb0d9731f4bd0079f65e59d17bce0d9c0bd4e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "87d973ba74d1738917f1c99acd608a1bd617e2d5c888d6ebc4067ec22dcb646d"
  end

  depends_on "openjdk"

  def install
    jar = "artemis-v#{version}.jar"
    libexec.install jar
    opts = "-Xmx1000m -Xms50m"

    bin.write_jar_script libexec/jar, "art", opts
    inreplace bin/"art", "-jar", "-cp"
    inreplace bin/"art", '"$@"', 'uk.ac.sanger.artemis.components.ArtemisMain "$@"'

    bin.write_jar_script libexec/jar, "act", opts
    inreplace bin/"act", "-jar", "-cp"
    inreplace bin/"act", '"$@"', 'uk.ac.sanger.artemis.components.ActMain "$@"'

    bin.write_jar_script libexec/jar, "dnaplotter", opts
    inreplace bin/"dnaplotter", "-jar", "-cp"
    inreplace bin/"dnaplotter", '"$@"', 'uk.ac.sanger.artemis.circular.DNADraw "$@"'

    bin.write_jar_script libexec/jar, "bamview", opts
    inreplace bin/"bamview", "-jar", "-cp"
    inreplace bin/"bamview", '"$@"', 'uk.ac.sanger.artemis.components.alignment.BamView "$@"'
  end

  test do
    # No test block because these tools are GUI only
    nil
  end
end
