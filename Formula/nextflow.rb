class Nextflow < Formula
  # cite Tommaso_2017: "https://doi.org/10.1038/nbt.3820"
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://github.com/nextflow-io/nextflow/releases/download/v19.04.1/nextflow"
  sha256 "21318d8b64095a548f6baf0ef2811f33452e4f9f8a502a46a0aab7815ee34c69"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7756ba884a26e1e5b8328131a0555c77436320581c97631581d853cc6759aa9e" => :sierra
    sha256 "f27ad17cbe742c3d719602bb1de9b8e2841a993e7324b64b7ebd4788d9ddb8ce" => :x86_64_linux
  end

  depends_on :java => "1.8"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    assert_match /hello\n$/, pipe_output("#{bin}/nextflow -q run -", "println 'hello'")
  end
end
