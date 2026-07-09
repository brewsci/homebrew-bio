class Interop < Formula
  desc "Parse Illumina InterOp sequencing run-metrics files"
  homepage "https://github.com/Illumina/interop"
  url "https://github.com/Illumina/interop/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "55d153bd0e97540907d816921823ac03cf2e38f78d44eecf977dac8c0e8a299f"
  license "GPL-3.0-only"
  head "https://github.com/Illumina/interop.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3dd89faaa8bbe2f77e8b2d99fec1141f0348b01dc7069083548e1b9dfc149f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d56e56c4db0400f33054e55e169a091c3a013b4320e4f30ee63ed248ecd617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5516255a953827c492519211811c40660993ef37670361384017628c7bb03e2"
    sha256 cellar: :any,                 x86_64_linux:  "5bcccaa9d03165bd007179b0b6f3db6fcf61b59cd40b7cbac5b50efbf1e5c2a5"
  end

  depends_on "cmake" => :build

  def install
    apps = %w[
      aggregate dumpbin dumptext imaging_table index-summary
      plot_by_cycle plot_by_lane plot_flowcell plot_qscore_heatmap
      plot_qscore_histogram plot_sample_qc summary
    ]
    args = %w[
      -DENABLE_SWIG=OFF -DENABLE_CSHARP=OFF -DENABLE_PYTHON=OFF
      -DENABLE_TEST=OFF -DENABLE_DOCS=OFF -DENABLE_EXAMPLES=OFF
      -DENABLE_DEPENDENCY_MANAGER=OFF
    ]
    # Upstream forces a universal "x86_64;arm64" build on macOS; pin to native.
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", *apps
    apps.each { |app| bin.install "build/src/apps/#{app}" }
  end

  test do
    assert_match "Usage: summary", shell_output("#{bin}/summary --help")
  end
end
