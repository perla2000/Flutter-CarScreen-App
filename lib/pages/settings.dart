import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../main.dart';

const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

// enum Color {
//   black,
//   white,
//   sysTheme,
// }



class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, this.navigatorKey}) : super(key: key);
  final GlobalKey? navigatorKey;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
        const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
        final tooltipThemeData = TooltipThemeData(decoration: () {
      const radius = BorderRadius.zero;
      final shadow = [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1, 1),
          blurRadius: 10.0,
        ),
      ];
      final border = Border.all(color: Colors.grey[100], width: 0.5);
      if (FluentTheme.of(context).brightness == Brightness.light) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      } else {
        return BoxDecoration(
          color: Colors.grey,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      }
    }());
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.fromLTRB(10,0,20,10),
        child: Text('Settings',
            style: FluentTheme.of(context)
                .typography
                .titleLarge
                ?.copyWith(fontSize: 40, fontWeight: FontWeight.w600)),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personalisation', style: FluentTheme.of(context).typography.subtitle),
            spacer,
            Expander(
                header: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: mat.MainAxisAlignment.start,
                    children: [
                  const mat.Icon(
                    mat.Icons.format_paint_outlined,
                    size: 20,
                  ),
                  const SizedBox(width: 10,),
                  mat.Text(
                    'App theme',
                    style: FluentTheme.of(context)
                        .typography
                        .subtitle
                        ?.copyWith(fontSize: 15),
                  ),
                      const Spacer(),
                      Text(appTheme.mode.name,style: FluentTheme.of(context).typography.subtitle?.copyWith(fontSize: 12),)
                ]),
                content: Column(
                  crossAxisAlignment: mat.CrossAxisAlignment.start,
                  children: [
                    ...List.generate(ThemeMode.values.length, (index) {
                      final mode = ThemeMode.values[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RadioButton(
                          checked: appTheme.mode == mode,
                          onChanged: (bool value) {
                            appTheme.mode = mode;
                          },
                          content: Text('$mode'.replaceAll('ThemeMode.', '')),
                        ),
                      );
                    })
                  ],
                )),
          spacer,
            Expander(
                header: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: mat.MainAxisAlignment.start,
                    children: [
                      const mat.Icon(
                        mat.Icons.format_color_fill_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 10,),
                      mat.Text(
                        'Accent color',
                        style: FluentTheme.of(context)
                            .typography
                            .subtitle
                            ?.copyWith(fontSize: 15),
                      ),
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 30,
                        color: appTheme.color,
                        alignment: Alignment.center,

                      ),
                    ]),
                content: Column(
                  crossAxisAlignment: mat.CrossAxisAlignment.start,
                  children: [
                  Wrap(children: [
            Tooltip(
              style: tooltipThemeData,
              child: _buildColorBlock(appTheme, systemAccentColor,),
              message: accentColorNames[0],
            ),
            ...List.generate(Colors.accentColors.length, (index) {
              final color = Colors.accentColors[index];
              return Tooltip(
                style: tooltipThemeData,
                message: accentColorNames[index + 1],
                child: _buildColorBlock(appTheme, color,accentColorNames[index+1]),
              );
            }),
          ]),
                  ],
                )),
            biggerSpacer,
            Text('About', style: FluentTheme.of(context).typography.subtitle),
            spacer,
            Table(
              children: const [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text('Version'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text('0.1.0-alpha'),
                  )
                ]),

              ],

            ),
            const Text(
              'Contact',
            ),
            //
            //


            biggerSpacer,
            biggerSpacer,
            biggerSpacer,
          ],

        ),
      ),
    );
  }

  Widget buildExpanderButtons(
      BuildContext context, Function onTap, Widget leading, Widget title) {
    return HoverButton(
      // key: key,
      onPressed: () {
        onTap;
      },
      builder: (context, states) {
        final theme = FluentTheme.of(context);
        final radius = BorderRadius.circular(4.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FocusBorder(
            focused: states.isFocused,
            renderOutside: true,
            style: FocusThemeData(borderRadius: radius),
            child: Container(
              decoration: BoxDecoration(
                color: ButtonThemeData.uncheckedInputColor(theme, states),
                borderRadius: radius,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: leading,
                  ),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: title,
                  ),
                //if (trailing != null) trailing!,
              ]),
            ),
          ),
        );
      },
    );
  }


  Widget _buildColorBlock(AppTheme appTheme, AccentColor color, [String? accentColorName]) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          appTheme.color = color;
          Hive.box('settings').put('accentColor', accentColorName );
        },
        style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
        child: Container(
          height: 40,
          width: 40,
          color: color,
          alignment: Alignment.center,
          child: appTheme.color == color
              ? Icon(
                  FluentIcons.check_mark,
                  color: color.basedOnLuminance(),
                  size: 22.0,
                )
              : null,
        ),
      ),
    );
  }
}
