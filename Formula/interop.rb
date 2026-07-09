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
