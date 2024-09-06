class D4tools < Formula
  # cite Hou_2021: "https://doi.org/10.1038/s43588-021-00085-0"
  desc "Dense Depth Data Dump (D4) Quantitative Data Format"
  homepage "https://github.com/38/d4-format"
  url "https://github.com/38/d4-format/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "d3fbe8f063ed1f89148ae0333abc1d5b955f499fc429254f83af464012678d33"
  license "MIT"
  head "https://github.com/38/d4-format.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "978cb404061b2a7d8c9faede802ae431c18dc66f4b15233dcad12fcd1a121553"
    sha256 cellar: :any,                 ventura:      "0f9c810503ff45c392a3877422a8371eea45788ba5024db52f00b5be3e9afddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79bf2718735b308a8d15511a2ff85c5e21cf6a29a173d69ee631eb533ebb83a5"
  end

  depends_on "rust" => :build
  depends_on "rustup"

  def install
    cd "d4tools" do
      system "cargo", "install", *std_cargo_args
    end
    cd "d4binding" do
      inreplace "install.sh", "PREFIX=/opt/local", "PREFIX=#{prefix}"
      system "./install.sh"
      rm "#{lib}/libd4binding.d"
    end
  end

  test do
    resource "small.bam" do
      url "https://github.com/38/d4-format/raw/master/d4tools/test/create/from-bam/small.bam"
      sha256 "1bb389b38901139bacbe70906b833a2e572676cd87783120193dd0902a63c0b1"
    end
    resource "small.bam.bai" do
      url "https://github.com/38/d4-format/raw/master/d4tools/test/create/from-bam/small.bam.bai"
      sha256 "a01a850ca0b331145f61048293cf71ecb264962348bd8ebfc9a1249eb95a0fa5"
    end
    resources.each { |r| r.stage(testpath) }
    system "#{bin}/d4tools", "create", "--mapping-qual", "0", "small.bam", "small.d4"
    assert_match "1\t10158\t20000\t0", shell_output("#{bin}/d4tools view small.d4")

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <d4.h>

      int main(int argc, char** argv)
      {
          d4_file_t* fp = d4_open("small.d4", "r");

          d4_file_metadata_t mt = {};
          d4_file_load_metadata(fp, &mt);

          int i;
          for(i = 0; i < mt.chrom_count; i++)
              printf("# %s %d", mt.chrom_name[i], mt.chrom_size[i]);

          d4_close(fp);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test",
                    "-ld4binding", "-I#{include}", "-L#{lib}"
    assert_match "# 1 20000", shell_output("./test")
  end
end
