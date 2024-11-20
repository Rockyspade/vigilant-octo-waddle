class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.4.tar.xz"
  sha256 "4c2d0a8b99df8915a87099607a8d912fd05d30651b6f014745c14e4ca8dbbfb7"
  license "GPL-2.0-or-later"
  head "https://git.zx2c4.com/password-store.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, ventura:        "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, monterey:       "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3104f2584abf3c35e811152282541832cc3e672d8b28024ee8d77d49cca172"
  end

  depends_on "gnu-getopt"
  depends_on "gnupg"
  depends_on "qrencode"
  depends_on "tree"

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}",
                   "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace bin/"pass",
              /^SYSTEM_EXTENSION_DIR=.*$/,
              "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/password-store/extensions\""
    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      system bin/"pass", "generate", "Email/testing@foo.bar", "15"
      assert_predicate testpath/".password-store/Email/testing@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end