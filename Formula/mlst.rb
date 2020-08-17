class Mlst < Formula
  desc "Multi-Locus Sequence Typing of bacterial contigs"
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/v2.19.0.tar.gz"
  sha256 "74403be717f0bffd579028fd8e7c02d826f5c896e38e6078271a59f7dfce2b0e"
  license "GPL-2.0"
  head "https://github.com/tseemann/mlst.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1798bf97d935367e32cb7c7854b25c5d04453c4ac5c00360b3c9c2969c77d110" => :catalina
    sha256 "1d618e68933b2866250ca1a60bb5e1e259890e17dbda5139afc03e4b64bb4a98" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build

  depends_on "blast"
  depends_on "brewsci/bio/any2fasta"
  depends_on "perl" # needs 5.26 so can't use Mac perl
  depends_on "wget"

  uses_from_macos "zlib"

  def install
    libexec.install Dir["*"]
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "Moo", "List::MoreUtils", "JSON"
    (bin/"mlst").write_env_script("#{libexec}/bin/mlst", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    tdir = libexec/"test"
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
    system "#{bin}/mlst", "--check"
    system "#{bin}/mlst -q #{tdir}/example.fna.gz | grep -w 184"
    system "#{bin}/mlst -q #{tdir}/example.gbk.gz | grep -w 184"
    system "gzip -d -c #{tdir}/example.fna.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "gzip -d -c #{tdir}/example.gbk.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "#{bin}/mlst -q --csv #{tdir}/example.fna.gz | grep ',184,'"
  end
end
