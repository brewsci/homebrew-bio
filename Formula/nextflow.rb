class Nextflow < Formula
  # cite Tommaso_2017: "https://doi.org/10.1038/nbt.3820"
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://github.com/nextflow-io/nextflow/releases/download/v24.10.1/nextflow"
  sha256 "fd034b2d854010c7dfb7ae1b54d29209f45a2735504fa9c34becac44201f9e75"
  license "Apache-2.0"
  head "https://github.com/nextflow-io/nextflow.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5651c31be9ccc02bf18476500954de6444c23fb16e7c20cbb65528c1c20ea4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5651c31be9ccc02bf18476500954de6444c23fb16e7c20cbb65528c1c20ea4f7"
    sha256 cellar: :any_skip_relocation, ventura:       "5651c31be9ccc02bf18476500954de6444c23fb16e7c20cbb65528c1c20ea4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32511428d01559082c3e177d80984281a6aca81c438e61b91902e2848e25089c"
  end

  depends_on "openjdk@17"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    assert_match(/hello\n$/, pipe_output("#{bin}/nextflow -q run -", "println 'hello'"))
  end
end
