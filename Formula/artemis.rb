class Artemis < Formula
  # cite Carver_2011: "https://doi.org/10.1093/bioinformatics/btr703"
  desc "Genome browser and annotation tool"
  homepage "https://www.sanger.ac.uk/science/tools/artemis"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v17/v17.0.1/artemis-v17.0.1.jar"
  sha256 "8703fd02df01084c8dcb06abf181b378cdf4dd9ba70d71fbd950c2056fefe932"
  # head "https://github.com/sanger-pathogens/Artemis"

  bottle :unneeded

  depends_on :java

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
  end

  test do
    # No test block because these tools are GUI only
  end
end
