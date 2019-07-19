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
    sha256 "0078a9ee2200c4a426759195c942f71f92cbc1451f765fd73547c094700c38e6" => :sierra
    sha256 "05ae7affdcba74c5eeff7c8bf7f6eaae396e3dc1263d4e70d2e00bbd6366e6ec" => :x86_64_linux
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
