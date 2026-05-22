/// Represents a single navigation item in the bottom navigation bar.
class NavItem {
  final String label;
  final dynamic icon; // Using dynamic because HugeIcons uses a custom type
  final String routePath;

  const NavItem({
    required this.label,
    required this.icon,
    required this.routePath,
  });
}
