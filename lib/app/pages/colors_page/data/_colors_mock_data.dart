part of '../colors_view.dart';

class GroupedColors {
  final String groupName;
  final List<ColorTiles> colors;

  const GroupedColors({
    required this.groupName,
    required this.colors,
  });
}

class ColorTiles {
  final String name;
  final Color color;
  const ColorTiles({
    required this.name,
    required this.color,
  });
}

List<GroupedColors> get  _colorMockData => <GroupedColors>[
  GroupedColors(
    //groupName: 'Bases',
    groupName: l.S.current.bases,
    colors: [
      ColorTiles(name: l.S.current.black, color: const Color(0xff000000)),
      ColorTiles(name: l.S.current.white, color: const Color(0xffFFFFFF)),
    ],
  ),
  GroupedColors(
    //groupName: 'Primary',
    groupName: l.S.current.primary,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffFAF4FF)),
      const ColorTiles(name: '100', color: Color(0xfff2e5ff)),
      const ColorTiles(name: '200', color: Color(0xffdac0fe)),
      const ColorTiles(name: '300', color: Color(0xffc194fe)),
      const ColorTiles(name: '400', color: Color(0xffa664ff)),
      const ColorTiles(name: '500', color: Color(0xff8424FF)),
      const ColorTiles(name: '600', color: Color(0xff7500fd)),
      const ColorTiles(name: '700', color: Color(0xff7500fd)),
      const ColorTiles(name: '800', color: Color(0xff6800f7)),
      const ColorTiles(name: '900', color: Color(0xff5400ef)),
    ],
  ),
  GroupedColors(
   // groupName: 'Secondary ',
    groupName: l.S.current.secondary,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffEFF6FF)),
      const ColorTiles(name: '100', color: Color(0xffDBEAFE)),
      const ColorTiles(name: '200', color: Color(0xffBFDBFE)),
      const ColorTiles(name: '300', color: Color(0xff93C5FD)),
      const ColorTiles(name: '400', color: Color(0xff60A5FA)),
      const ColorTiles(name: '500', color: Color(0xff3B82F6)),
      const ColorTiles(name: '600', color: Color(0xff2563EB)),
      const ColorTiles(name: '700', color: Color(0xff1D4ED8)),
      const ColorTiles(name: '800', color: Color(0xff1E40AF)),
      const ColorTiles(name: '900', color: Color(0xff1E3A8A)),
    ],
  ),
  GroupedColors(
    //groupName: 'Neutral',
    groupName: l.S.current.neutral,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffD9D9D9)),
      const ColorTiles(name: '100', color: Color(0xffFAFBFD)),
      const ColorTiles(name: '200', color: Color(0xffEAECF0)),
      const ColorTiles(name: '300', color: Color(0xffD0D5DD)),
      const ColorTiles(name: '400', color: Color(0xff98A2B3)),
      const ColorTiles(name: '500', color: Color(0xff667085)),
      const ColorTiles(name: '600', color: Color(0xff475467)),
      const ColorTiles(name: '700', color: Color(0xff344054)),
      const ColorTiles(name: '800', color: Color(0xff1D2939)),
      const ColorTiles(name: '900', color: Color(0xff101828)),
    ],
  ),
  GroupedColors(
    //groupName: 'Success',
    groupName: l.S.current.success,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffF0FDF4)),
      const ColorTiles(name: '100', color: Color(0xffDCFCE7)),
      const ColorTiles(name: '200', color: Color(0xffBBF7D0)),
      const ColorTiles(name: '300', color: Color(0xff86EFAC)),
      const ColorTiles(name: '400', color: Color(0xff4ADE80)),
      const ColorTiles(name: '500', color: Color(0xff22C55E)),
      const ColorTiles(name: '600', color: Color(0xff16A34A)),
      const ColorTiles(name: '700', color: Color(0xff15803D)),
      const ColorTiles(name: '800', color: Color(0xff166534)),
      const ColorTiles(name: '900', color: Color(0xff14532D)),
    ],
  ),
  GroupedColors(
    //groupName: 'Info ',
    groupName: l.S.current.info,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffEFF6FF)),
      const ColorTiles(name: '100', color: Color(0xffDBEAFE)),
      const ColorTiles(name: '200', color: Color(0xffBFDBFE)),
      const ColorTiles(name: '300', color: Color(0xff93C5FD)),
      const ColorTiles(name: '400', color: Color(0xff60A5FA)),
      const ColorTiles(name: '500', color: Color(0xff3B82F6)),
      const ColorTiles(name: '600', color: Color(0xff2563EB)),
      const ColorTiles(name: '700', color: Color(0xff1D4ED8)),
      const ColorTiles(name: '800', color: Color(0xff1E40AF)),
      const ColorTiles(name: '900', color: Color(0xff1E3A8A)),
    ],
  ),
  GroupedColors(
    //groupName: 'Warning ',
    groupName:l.S.current.warning,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffFEFCE8)),
      const ColorTiles(name: '100', color: Color(0xffFEF9C3)),
      const ColorTiles(name: '200', color: Color(0xffFEF08A)),
      const ColorTiles(name: '300', color: Color(0xffFDE047)),
      const ColorTiles(name: '400', color: Color(0xffFACC15)),
      const ColorTiles(name: '500', color: Color(0xffEAB308)),
      const ColorTiles(name: '600', color: Color(0xffCA8A04)),
      const ColorTiles(name: '700', color: Color(0xffA16207)),
      const ColorTiles(name: '800', color: Color(0xff854D0E)),
      const ColorTiles(name: '900', color: Color(0xff713F12)),
    ],
  ),
  GroupedColors(
    //groupName: 'Error',
    groupName: l.S.current.Error,
    colors: [
      const ColorTiles(name: '50', color: Color(0xffFEF2F2)),
      const ColorTiles(name: '100', color: Color(0xffFEE2E2)),
      const ColorTiles(name: '200', color: Color(0xffFECACA)),
      const ColorTiles(name: '300', color: Color(0xffFCA5A5)),
      const ColorTiles(name: '400', color: Color(0xffF87171)),
      const ColorTiles(name: '500', color: Color(0xffEF4444)),
      const ColorTiles(name: '600', color: Color(0xffDC2626)),
      const ColorTiles(name: '700', color: Color(0xffB91C1C)),
      const ColorTiles(name: '800', color: Color(0xff991B1B)),
      const ColorTiles(name: '900', color: Color(0xff7F1D1D)),
    ],
  ),
];
