import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Maazym - Restaurant Management System",
  description: "Comprehensive restaurant management system",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html suppressHydrationWarning>
      <body className="min-h-full flex flex-col bg-background text-foreground">
        {children}
      </body>
    </html>
  );
}
