class Nextflow < Formula
  # cite Tommaso_2017: "https://doi.org/10.1038/nbt.3820"
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://github.com/nextflow-io/nextflow/releases/download/v21.04.1/nextflow"
  sha256 "840ca394237e0f4d9f34642ff77c0ac92361319bcc9d9441f3d99f7b6d48ae7d"
  license "Apache-2.0"
  head "https://github.com/nextflow-io/nextflow.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "6cb66055fa3db10517866c52b5e63b041445117a279701e865284c62585f94d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "88f2bab19c5a735bfc714f64c9bcbd6293d2883713b4dee8ea5b171d6be5bcef"
  end

  depends_on "openjdk"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    assert_match(/hello\n$/, pipe_output("#{bin}/nextflow -q run -", "println 'hello'"))
  end
end
