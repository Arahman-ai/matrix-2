#!/usr/bin/env bash
# ============================================================
#  Rangu Digital — Phone Number Fix Script
#
#  CALL number  : (770) 609-7666   → tel: links & call display text
#  WHATSAPP     : +880 181-395-6455 → wa.me/ links & WA display text
#
#  Run from the ROOT of your local bridgebay-digital folder:
#    bash fix-numbers.sh
# ============================================================

set -e

NEW_WA_LINK="8801813956455"          # for wa.me/XXXXXX
NEW_WA_DISPLAY="+880 181-395-6455"   # shown next to WhatsApp labels
NEW_CALL_LINK="+17706096766"          # for tel: href
NEW_CALL_DISPLAY="(770) 609-7666"    # shown next to call/phone labels

FILES=(
  index.html
  pricing.html
  thanks.html
  digital-marketing.html
  business-automation.html
  software-development.html
  ai-for-business.html
  manufacturing.html
  enterprise-it.html
  results.html
  login.html
  signup.html
  reset.html
  onboarding.html
  dashboard.html
  admin.html
  review-request.html
)

CHANGED=0

for FILE in "${FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo "⚠️  Skipping (not found): $FILE"
    continue
  fi

  BEFORE=$(cat "$FILE")

  # ── 1. WhatsApp wa.me links ──────────────────────────────────
  sed -i "s|wa\.me/19125419169|wa.me/${NEW_WA_LINK}|g"    "$FILE"
  sed -i "s|wa\.me/14706156766|wa.me/${NEW_WA_LINK}|g"    "$FILE"
  sed -i "s|wa\.me/8801813956455|wa.me/${NEW_WA_LINK}|g"  "$FILE"  # idempotent

  # ── 2. tel: call links ───────────────────────────────────────
  sed -i "s|tel:+19125419169|tel:${NEW_CALL_LINK}|g"      "$FILE"
  sed -i "s|tel:+14706156766|tel:${NEW_CALL_LINK}|g"      "$FILE"
  sed -i "s|tel:19125419169|tel:${NEW_CALL_LINK}|g"        "$FILE"
  sed -i "s|tel:14706156766|tel:${NEW_CALL_LINK}|g"        "$FILE"

  # ── 3. WhatsApp display text (numbers shown next to WA icon/label) ──
  #    These appear inside <a href="wa.me/..."> anchors or "WhatsApp" contexts
  sed -i "s|+1 912-541-9169|${NEW_WA_DISPLAY}|g"          "$FILE"
  sed -i "s|+1 470-615-6766|${NEW_WA_DISPLAY}|g"          "$FILE"
  sed -i "s|912-541-9169|${NEW_WA_DISPLAY}|g"              "$FILE"
  sed -i "s|470-615-6766|${NEW_WA_DISPLAY}|g"              "$FILE"

  # ── 4. Call display text (standalone phone number displays) ──
  #    (770) 609-7666 is the call-only US number — keep as-is or normalise
  sed -i "s|(770) 609-7666|${NEW_CALL_DISPLAY}|g"          "$FILE"
  sed -i "s|770-609-7666|${NEW_CALL_DISPLAY}|g"            "$FILE"
  sed -i "s|+1 770-609-7666|${NEW_CALL_DISPLAY}|g"         "$FILE"

  AFTER=$(cat "$FILE")
  if [ "$BEFORE" != "$AFTER" ]; then
    echo "✅  Updated: $FILE"
    CHANGED=$((CHANGED + 1))
  else
    echo "   No change: $FILE"
  fi
done

echo ""
echo "──────────────────────────────────────────"
echo "Done — ${CHANGED} file(s) updated."
echo ""
echo "Verify no old numbers remain:"
echo "  grep -rn '9125419\|4706156\|912-541\|470-615' *.html"
echo ""
echo "Commit & push:"
echo "  git add -A"
echo "  git commit -m \"fix: update phone numbers (call 770, WA +880)\""
echo "  git push"
