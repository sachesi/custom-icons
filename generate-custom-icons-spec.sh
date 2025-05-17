#!/usr/bin/env bash

# The following Bash script automates the generation of an RPM .spec file for
# the purpose of packaging all icons located under a given directory structure,
# specifically tailored for the hicolor icon theme directory
# (e.g., icons/hicolor/256x256/apps/).
# The script performs recursive discovery of PNG icons within this directory,
# replicates the %install and %files sections accordingly, and produces a valid .spec file
# based on your provide id template.

# You must be in dir where spec must be generated.

#!/usr/bin/env bash

set -e

PARENT_FOLDER="$(basename "$PWD")"
SPEC_FILE="${PARENT_FOLDER}.spec"
ICON_DIR="icons/hicolor"
CHANGELOG_MD="CHANGELOG.md"
SUPPORTED_EXTENSIONS="png svg xpm"

# Get maintainer info
RPM_USER="${RPM_PACKAGER:-$(id -un)}"
RPM_EMAIL="${RPM_EMAIL:-${RPM_USER}@localhost}"

# Parse latest version-release from CHANGELOG.md
if [[ -f "$CHANGELOG_MD" ]]; then
    read -r VERSION_LINE < <(grep -m1 -E '^## \[[0-9]+\.[0-9]+-[0-9]+\] - ' "$CHANGELOG_MD")
    if [[ "$VERSION_LINE" =~ \[\s*([0-9]+)\.([0-9]+)-([0-9]+)\s*\] ]]; then
        VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
        RELEASE="${BASH_REMATCH[3]}"
    else
        echo "❌ Could not parse version from CHANGELOG.md"
        exit 1
    fi
else
    echo "❌ No CHANGELOG.md file found."
    exit 1
fi

# Begin spec file
cat > "$SPEC_FILE" <<EOF
Name:           ${PARENT_FOLDER}
Version:        ${VERSION}
Release:        ${RELEASE}%{?dist}
Summary:        Custom icons for my .desktop files

License:        CC0
BuildArch:      noarch

%description
Installs custom icons for my .desktop files to the system icon directory.

%install
EOF

# Collect icon files
icon_files=()
for ext in $SUPPORTED_EXTENSIONS; do
    while IFS= read -r -d '' file; do
        icon_files+=("$file")
    done < <(find "$ICON_DIR" -type f -iname "*.$ext" -print0)
done

# Install section
for icon in "${icon_files[@]}"; do
    relpath="${icon#icons/}"
    target_dir="%{buildroot}/usr/share/icons/${relpath%/*}"
    echo "mkdir -p \"$target_dir\"" >> "$SPEC_FILE"
    echo "cp -a \"$icon\" \"$target_dir/\"" >> "$SPEC_FILE"
done

# Files section
echo -e "\n\n%files" >> "$SPEC_FILE"
echo "%license" >> "$SPEC_FILE"
for icon in "${icon_files[@]}"; do
    relpath="${icon#icons/}"
    echo "/usr/share/icons/$relpath" >> "$SPEC_FILE"
done

# Post and postun
cat >> "$SPEC_FILE" <<'EOF'

%post
if [ -x /usr/bin/gtk-update-icon-cache ]; then
  /usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor || :
fi

%postun
if [ -x /usr/bin/gtk-update-icon-cache ]; then
  /usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor || :
fi

%changelog
EOF

# Add RPM-style changelog entries
awk -v user="$RPM_USER" -v email="$RPM_EMAIL" '
BEGIN {
    entry = ""
}
/^## \[[0-9]+\.[0-9]+-[0-9]+\] - [0-9]{4}-[0-9]{2}-[0-9]{2}/ {
    if (entry) print entry "\n"
    match($0, /\[([0-9]+\.[0-9]+)-([0-9]+)\] - ([0-9]{4})-([0-9]{2})-([0-9]{2})/, parts)
    version = parts[1]
    release = parts[2]
    y = parts[3]
    m = parts[4]
    d = parts[5]
    cmd = "LC_TIME=C date -u -d \"" y "-" m "-" d "\" +\"* %a %b %d %Y " user " <" email "> - " version "-" release "\""
    cmd | getline header
    close(cmd)
    entry = header
    next
}
/^-/ { entry = entry "\n" $0 }
END { if (entry) print entry }
' "$CHANGELOG_MD" >> "$SPEC_FILE"

echo "✅ Spec file with version $VERSION-$RELEASE and changelog: $SPEC_FILE"
