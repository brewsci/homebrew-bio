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
    sha256 cellar: :any_skip_relocation, catalina:     "96dc9aafdb0ef9804017f32200c738cbe3e5856be40ac2d9dfb865d79268605a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3547d7f7f5a11ef0bb57e55230e28e1bc410882dd7bd2d3f75949e94522f8112"
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
