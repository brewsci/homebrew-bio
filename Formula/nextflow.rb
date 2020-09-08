class Nextflow < Formula
  # cite Tommaso_2017: "https://doi.org/10.1038/nbt.3820"
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://github.com/nextflow-io/nextflow/releases/download/v20.07.1/nextflow"
  sha256 "de4db5747a801af645d9b021c7b36f4a25c3ce1a8fda7705a5f37e8f9357443a"
  license "Apache-2.0"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6cb66055fa3db10517866c52b5e63b041445117a279701e865284c62585f94d1" => :catalina
    sha256 "88f2bab19c5a735bfc714f64c9bcbd6293d2883713b4dee8ea5b171d6be5bcef" => :x86_64_linux
  end

  depends_on java: "1.8"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    assert_match /hello\n$/, pipe_output("#{bin}/nextflow -q run -", "println 'hello'")
  end
end
