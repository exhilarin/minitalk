/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client_bonus.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iguney <iguney@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/15 15:29:58 by iguney            #+#    #+#             */
/*   Updated: 2025/03/15 16:49:48 by iguney           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk_bonus.h"

volatile sig_atomic_t	g_signal_check = 0;

void	signal_handler(int signal_number)
{
	if (signal_number == SIGUSR1)
		g_signal_check = 1;
	else
		exit(EXIT_FAILURE);
}

void	bit_converter(int server_pid, char *str)
{
	int	i;
	int	bit;

	i = -1;
	while (str[++i])
	{
		bit = 8;
		while (--bit >= 0)
		{
			g_signal_check = 0;
			if ((str[i] >> bit) & 1)
				kill(server_pid, SIGUSR1);
			else
				kill(server_pid, SIGUSR2);
			while (g_signal_check == 0)
				pause();
		}
	}
	if (str[0] != '\n')
		ft_printf("Message received.\n");
}

int	main(int ac, char *av[])
{
	pid_t	server_pid;
	char	*str;

	if (ac == 3)
	{
		server_pid = ft_atoi(av[1]);
		if (kill(server_pid, 0) == -1 || server_pid > 4194304
			|| server_pid == -1)
			return (ft_printf("Invalid PID\n"), 1);
		str = av[2];
		signal(SIGUSR1, signal_handler);
		bit_converter(server_pid, str);
		bit_converter(server_pid, "\n");
	}
	else
		ft_printf("Error: %s - Usage: <program> <PID> <message>\n", av[0]);
	return (0);
}
