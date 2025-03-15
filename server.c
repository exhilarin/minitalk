/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iguney <iguney@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/15 15:29:35 by iguney            #+#    #+#             */
/*   Updated: 2025/03/15 16:50:20 by iguney           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

void	bit_receiver(int signal, siginfo_t *info, void *context)
{
	static int	i = 0;
	static int	c = 0;

	(void)context;
	if (signal == SIGUSR2)
		c = c << 1;
	else if (signal == SIGUSR1)
		c = (c << 1) | 1;
	i++;
	if (i == 7)
	{
		ft_printf("%c", c);
		i = 0;
		c = 0;
	}
	kill(info->si_pid, SIGUSR1);
}

int	main(void)
{
	struct sigaction	sa;
	pid_t				server_pid;

	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_SIGINFO;
	sa.sa_sigaction = bit_receiver;
	if (sigaction(SIGUSR1, &sa, NULL) == -1
		|| sigaction(SIGUSR2, &sa, NULL) == -1)
		return (ft_printf("sigaction() call failed.\n"), 1);
	server_pid = getpid();
	ft_printf("Server PID: %d\n", server_pid);
	while (1)
		pause();
	return (0);
}
