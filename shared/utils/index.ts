import * as types from '../types';
import * as constants from '../constants';

/**
 * Formats a number as a currency string
 * @param value The number to format
 * @param currencyCode The currency code to use (default: DEFAULT_CURRENCY)
 * @returns Formatted currency string
 */
export function formatCurrency(value: number, currencyCode: string = constants.DEFAULT_CURRENCY): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: currencyCode,
  }).format(value);
}

/**
 * Calculates the Return on Investment (ROI)
 * @param initialInvestment The initial investment amount
 * @param currentValue The current value of the investment
 * @returns Calculated ROI as a percentage
 */
export function calculateROI(initialInvestment: number, currentValue: number): number {
  const gain = currentValue - initialInvestment;
  return (gain / initialInvestment) * 100;
}

/**
 * Formats a date string or Date object to a specified format
 * @param date The date to format
 * @param format The format to use (default: DATE_FORMAT.DISPLAY)
 * @returns Formatted date string
 */
export function formatDate(date: Date | string, format: string = constants.DATE_FORMAT.DISPLAY): string {
  const dateObject = typeof date === 'string' ? new Date(date) : date;
  // Note: Implement date formatting logic here or use a library like date-fns
  // This is a placeholder implementation
  return dateObject.toLocaleDateString();
}

/**
 * Validates an email address
 * @param email The email address to validate
 * @returns True if the email is valid, false otherwise
 */
export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Truncates a string to a specified length with an optional suffix
 * @param str The string to truncate
 * @param maxLength The maximum length of the truncated string
 * @param suffix The suffix to append if truncated (default: '...')
 * @returns Truncated string
 */
export function truncateString(str: string, maxLength: number, suffix: string = '...'): string {
  if (str.length <= maxLength) return str;
  return str.slice(0, maxLength - suffix.length) + suffix;
}

/**
 * Calculates the Internal Rate of Return (IRR) for a series of cash flows
 * @param cashFlows An array of cash flows
 * @returns Calculated IRR as a percentage
 */
export function calculateIRR(cashFlows: number[]): number {
  // Note: This is a placeholder implementation
  // A robust IRR calculation algorithm should be implemented here
  // Consider using a financial mathematics library for complex calculations
  console.warn('IRR calculation not implemented');
  return 0;
}

// Add any additional utility functions here