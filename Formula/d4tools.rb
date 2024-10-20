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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ab6decc49fd87b0fe22c3a3d8db84b7d24406600fee48cc8f5a4eed8fc798fe4"
    sha256 cellar: :any,                 arm64_sonoma:  "5d8b75e4a64ca82263019a608291f213f15ab39cc9ff3e36442f6b1e69544986"
    sha256 cellar: :any,                 ventura:       "d6813d4a90fdffc82d8dc7d2cf20b3fb27ee2ee999a6f31af738fd931995a093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4e643f67b17bf4606be5c4a3803582e9ed5847a503b71e8851383ba05adfb4"
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
