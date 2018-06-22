class SimulatePcr < Formula
  # cite Gardner_2014: "https://doi.org/10.1186/1471-2105-15-237"
  desc "Predicts amplicon products from single or multiplex primers"
  homepage "https://sourceforge.net/projects/simulatepcr/"
  url "https://downloads.sourceforge.net/project/simulatepcr/simulate_PCR-v1.2.tar.gz"
  sha256 "022d1cc595d78a03b6a8a982865650f99d9fa067997bfea574c2416cc462e982"

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "blast"
  depends_on "perl" unless OS.mac?

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
