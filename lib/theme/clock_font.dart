import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Curated designer typography styles
class ClockFont {
  final String name;
  final String style;
  final TextStyle Function(TextStyle base) builder;

  const ClockFont({
    required this.name,
    required this.style,
    required this.builder,
  });
}

final List<ClockFont> kFonts = [
  ClockFont(
    name: 'Bebas Neue',
    style: 'Bold Condensed Horology',
    builder: (b) => GoogleFonts.bebasNeue(textStyle: b),
  ),
  ClockFont(
    name: 'Orbitron',
    style: 'Sci-Fi Cyberpunk',
    builder: (b) => GoogleFonts.orbitron(textStyle: b),
  ),
  ClockFont(
    name: 'Space Mono',
    style: 'Hacker Terminal Monospace',
    builder: (b) => GoogleFonts.spaceMono(textStyle: b),
  ),
  ClockFont(
    name: 'Oswald',
    style: 'Industrial Architecture',
    builder: (b) => GoogleFonts.oswald(textStyle: b),
  ),
  ClockFont(
    name: 'Montserrat',
    style: 'Clean Geometric Bauhaus',
    builder: (b) => GoogleFonts.montserrat(textStyle: b),
  ),
  ClockFont(
    name: 'Playfair Display',
    style: 'Luxury Swiss Horology Serif',
    builder: (b) => GoogleFonts.playfairDisplay(textStyle: b),
  ),
  ClockFont(
    name: 'Syne',
    style: 'Radical Avant-Garde',
    builder: (b) => GoogleFonts.syne(textStyle: b),
  ),
  ClockFont(
    name: 'JetBrains Mono',
    style: 'Precision Engineering',
    builder: (b) => GoogleFonts.jetBrainsMono(textStyle: b),
  ),
  ClockFont(
    name: 'Anton',
    style: 'Ultra-Heavy Headline',
    builder: (b) => GoogleFonts.anton(textStyle: b),
  ),
  ClockFont(
    name: 'Cinzel',
    style: 'Imperial Chiseled Stone',
    builder: (b) => GoogleFonts.cinzel(textStyle: b),
  ),
  ClockFont(
    name: 'Audiowide',
    style: 'Digital Hypercar Dashboard',
    builder: (b) => GoogleFonts.audiowide(textStyle: b),
  ),
  ClockFont(
    name: 'Comfortaa',
    style: 'Smooth Futuristic Rounded',
    builder: (b) => GoogleFonts.comfortaa(textStyle: b),
  ),
  ClockFont(
    name: 'Righteous',
    style: 'Electric Art Deco',
    builder: (b) => GoogleFonts.righteous(textStyle: b),
  ),
  ClockFont(
    name: 'Silkscreen',
    style: '8-Bit Retro Arcade',
    builder: (b) => GoogleFonts.silkscreen(textStyle: b),
  ),
  ClockFont(
    name: 'Major Mono',
    style: 'Minimalist Abstract Mono',
    builder: (b) => GoogleFonts.majorMonoDisplay(textStyle: b),
  ),
  ClockFont(
    name: 'System Monospace',
    style: 'Offline Hardware Terminal',
    builder: (b) => b.copyWith(fontFamily: 'monospace'),
  ),
];
