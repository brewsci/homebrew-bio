class Clonalframeml < Formula
  # cite Didelot_2015: "https://doi.org/10.1371/journal.pcbi.1004041"
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  url "https://github.com/xavierdidelot/ClonalFrameML/archive/refs/tags/v1.20.tar.gz"
  sha256 "ae797b187793599876a325cd5011959c82fc2b0f72b11b973b0cd1a3d47f6fb2"
  license "GPL-3.0"
  head "https://github.com/xavierdidelot/ClonalFrameML.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f003ce3e54ec0139dcdc3b9ce53a4bf12c2739e94a2abdf181740672f76ee76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f7abc279d17bf83855db8722e409ba9a734380bc48fdf8149d439b5a30ad358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e1058f1102f19d0ae4109744dfdb31eaff6fa679453b3c035e4a4cf4b4e394"
    sha256 cellar: :any,                 x86_64_linux:  "fadfd2dbf4be0f38aa29827469609d28a9d71d9441efe5706fe062444de1b70e"
  end

  def install
    system "make", "-C", "src"
    bin.install "src/ClonalFrameML"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ClonalFrameML -version 2>&1")
    assert_match "recombination", shell_output("#{bin}/ClonalFrameML -h 2>&1")
  end
end
