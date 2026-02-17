Name:           custom-icons
Version:        0.2
Release:        12%{?dist}
Summary:        Custom icons for my .desktop files

License:        MIT
BuildArch:      noarch

%description
Installs custom icons for my .desktop files to the system icon directory.

%install
install -d %{buildroot}/usr/share/icons/hicolor/256x256/apps
install -m 0644 icons/hicolor/256x256/apps/*.png \
    %{buildroot}/usr/share/icons/hicolor/256x256/apps/

%files
/usr/share/icons/hicolor/256x256/apps/*.png

%post
if [ -x /usr/bin/gtk-update-icon-cache ]; then
  /usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor || :
fi

%postun
if [ -x /usr/bin/gtk-update-icon-cache ]; then
  /usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor || :
fi

%changelog
* Tue Feb 17 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-12
- Add sonic-unleashed icon.

* Tue Jan 27 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-11
- Add sonic-unleashed icon.

* Sat Jan 10 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-10
- Add fall-of-avalon icon.

* Fri Jan 09 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-9
- Change baldurs-gate-3 icon.

* Mon Jan 05 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-8
- Add no-rest-for-the-wicked and middle-earth-shadow-of-mordor icon,
  modify darksiders-i, darksiders-ii, windbound and wwm icons.

* Mon Jan 05 2026 sachesi x <sachesi.bb.passp@proton.me> - 0.2-7
- Add sky-childrten-of-the-light icon.

* Sat Dec 20 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-6
- Convert tails-of-iron to png format, rename the-last-campfile to the-last-campfire icon.

* Sat Dec 20 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-5
- Add the-last-campfile icon.

* Sat Dec 20 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-4
- Add tails-of-iron icon.

* Thu Dec 18 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-3
- Add pw2 icon.

* Sat Nov 15 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-2
- Add wwm icon.

* Wed Nov 5 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-1
- Add sekiro icons.

* Mon Nov 3 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.2-0
- Add nioh and nioh-2 icons.

* Thu Aug 14 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-8
- Add silksong icon, change evolved-pwi icon.

* Thu Aug 14 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-7
- Add bdo icon.

* Thu Jul 17 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-6
- Add firefox-private icon.

* Sun Jun 22 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-5
- Add citron and tkmm icon.

* Mon May 26 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-4
- Add last-epoch icon.

* Fri May 23 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-3
- Add eden icon.

* Thu May 22 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-2
- Add inzoi icon.

* Sun May 18 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-1
- Add yazi icon.

* Sat May 17 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1-0
- Initial icon packaging.
