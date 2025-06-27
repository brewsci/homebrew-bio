class SimulatePcr < Formula
  # cite Gardner_2014: "https://doi.org/10.1186/1471-2105-15-237"
  desc "Predicts amplicon products from single or multiplex primers"
  homepage "https://sourceforge.net/projects/simulatepcr/"
  url "https://downloads.sourceforge.net/project/simulatepcr/simulate_PCR-v1.2.tar.gz"
  sha256 "022d1cc595d78a03b6a8a982865650f99d9fa067997bfea574c2416cc462e982"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "94c61331f686467bc1d901e79c4f140313f01f94b3c65855a72716dc1a35e586"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c74c5e247d9fcc9d8e9a4a60e363e8a8b2c5029496141cdeb7bc5cb218d565d5"
  end

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "blast"

  uses_from_macos "perl"

  def install
    bin.install "simulate_PCR"
    inreplace bin/"simulate_PCR", "#!/usr/bin/perl", "#!/usr/bin/env perl"
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "IO::Socket::SSL", "LWP"
    bin.env_script_all_files libexec, "PERL5LIB" => ENV["PERL5LIB"]
  end

  test do
    assert_match "amplicon", shell_output("#{bin}/simulate_PCR 2>&1", 255)
  end
end
