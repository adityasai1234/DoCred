import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/contexts/ThemeContext";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Cabingo - Find the Cheapest Cab Prices",
  description: "Compare cab prices across Uber, Lyft, and local taxi services in your area. Find the cheapest rides within 50m-100m range.",
  keywords: "cab comparison, uber, lyft, taxi, ride sharing, price comparison, cheapest cab",
  authors: [{ name: "Cabingo Team" }],
  viewport: "width=device-width, initial-scale=1",
  robots: "index, follow",
  openGraph: {
    title: "Cabingo - Find the Cheapest Cab Prices",
    description: "Compare cab prices across multiple platforms and find the best deals in your area.",
    type: "website",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: "Cabingo - Find the Cheapest Cab Prices",
    description: "Compare cab prices across multiple platforms and find the best deals in your area.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${inter.className} transition-colors duration-300`}>
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
