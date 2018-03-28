class Nextflow < Formula
  # Tommaso_2017: "https://doi.org/10.1038/nbt.3820"
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://github.com/nextflow-io/nextflow/releases/download/v0.28.1/nextflow"
  sha256 "012064b7938a719e4ed1ea56c4b7e8e20ea9562e63b696ca54680649434c7d57"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    output = pipe_output("#{bin}/nextflow -q run -", "println 'hello'").chomp
    assert_equal "hello", output
  end
end
