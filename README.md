🚨 Lua Anti-Cheat Scripts | Lua Anti-Hile Kodları 🚨

Bu repoda sunucularınızda güvenliği artırmak için kullanabileceğiniz Lua tabanlı anti-cheat scriptlerini bulabilirsiniz. 👾

In this repository, you'll find Lua-based anti-cheat scripts to enhance security in your FiveM Server. 🎮

📌 İçerik / Contents

🔒 Anti NoClip

Oyuncuların duvarlardan geçmesini engeller.

Prevents players from passing through walls.

🛡️ Anti Speed Hack

Oyuncu hızını kontrol eder ve aşırı hızlı hareketleri engeller.

Controls player speed and prevents excessively fast movements.

📡 Anti Teleport

Oyuncuların izinsiz ışınlanmasını engeller.

Prevents unauthorized player teleportation.

⚙️ Kurulum / Installation

Dosyaları projenize dahil edin ve scriptleri oyun motorunuzdaki Lua ortamına entegre edin.

Include the files in your project and integrate scripts into your game's Lua environment.

-- Örnek kullanım / Example usage
local anticheat = require('anticheat')
anticheat.enableNoClipProtection()

