class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/ff/46/8b697d7976ceccd4971886f04b57ec3ef46d8976b2beefa97892bfa35271/pspdfutils-3.3.5.tar.gz"
  sha256 "49d0ed8254df3fe60eb4fd74d4dc1ccaf08cc7802ea9d79d83670b45685d5e35"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, sonoma:         "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, ventura:        "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, monterey:       "e48238baab7620695b63785748c64f2f342ed45eef497abca867d109b0e84e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ce27b130f85c8ebb56213cf7a41b460f031cd62c76c6c0d07c4f09f1f4f16d"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d5/ce/dc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267/puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/f0/65/2ed7c9e1d31d860f096061b3dd2d665f501e09faaa0409a3f0d719d2a16d/pypdf-4.3.1.tar.gz"
    sha256 "b2f37fe9a3030aa97ca86067a56ba3f9d3565f9a791b305c7355d8392c30d91b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end